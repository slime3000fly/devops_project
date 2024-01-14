import React, { useState } from 'react';
import { Container, TextField, Button, Typography, List, ListItem } from '@mui/material';

function MovieRecommendations() {
    const [userId, setUserId] = useState('');
    const [numRecommendations, setNumRecommendations] = useState(5);
    const [recommendations, setRecommendations] = useState([]);
    
    const getRecommendations = () => {
      // Ensure numRecommendations is parsed as an integer
      const requestData = {
          userId: userId,
          numRecommendations: parseInt(numRecommendations, 10),
      };
  
      // Make a POST request to the Flask backend
      fetch('http://localhost:5000/predict', {
          method: 'POST',
          headers: {
              'Content-Type': 'application/json',
          },
          body: JSON.stringify(requestData),
      })
      .then(response => response.json())
      .then(data => {
          if (data.recommendations) {
              setRecommendations(data.recommendations);
          } else {
              console.error('No recommendations found in the response:', data);
          }
      })
      .catch(error => {
          console.error('Error:', error);
      });
  };

    return (
        <Container maxWidth="sm">
            <Typography variant="h3" color="primary" align="center" gutterBottom>
                Movie Recommendation System
            </Typography>
            <TextField
                fullWidth
                label="Enter User ID"
                variant="outlined"
                margin="normal"
                value={userId}
                onChange={(e) => setUserId(e.target.value)}
            />
            <TextField
                fullWidth
                label="Number of Recommendations"
                variant="outlined"
                type="number"
                margin="normal"
                value={numRecommendations}
                InputProps={{ inputProps: { min: 1, max: 10 } }}
                onChange={(e) => setNumRecommendations(e.target.value)}
            />
            <Button
                variant="contained"
                color="primary"
                fullWidth
                onClick={getRecommendations}
                style={{ marginTop: '20px' }}
            >
                Get Recommendations
            </Button>

            <Typography variant="h5" style={{ marginTop: '20px' }}>
                Recommendations:
            </Typography>
            <List>
                {recommendations.map((movie, index) => (
                    <ListItem key={index}>
                        <Typography>{movie}</Typography>
                    </ListItem>
                ))}
            </List>
        </Container>
    );
}

export default MovieRecommendations;
