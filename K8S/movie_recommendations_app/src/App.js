import React, { useState } from 'react';
import { Container, TextField, Button, Typography, List, ListItem, Card, CardContent } from '@mui/material';

function MovieRecommendations() {
    const [userId, setUserId] = useState('');
    const [numRecommendations, setNumRecommendations] = useState(5);
    const [recommendations, setRecommendations] = useState([]);

    const getRecommendations = () => {
        const requestData = {
            userId: userId,
            numRecommendations: parseInt(numRecommendations, 10),
        };

        fetch('/predict', {
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
                {recommendations.map((recommendation, index) => (
                    <ListItem key={index}>
                        <Card>
                            <CardContent>
                                <Typography>
                                    Title: {recommendation.title}, Accurate: {recommendation.recommendationScore}
                                </Typography>
                                <img
                                    alt={`Movie ${index + 1}`}
                                    src={recommendation.photoData ? `data:image/jpeg;base64,${recommendation.photoData}` : 'https://www.itatools.com.pl/img/no-photo-available.png'}
                                    style={{ maxWidth: '100%', marginTop: '10px' }}
                                />
                            </CardContent>
                        </Card>
                    </ListItem>
                ))}
            </List>
        </Container>
    );
}

export default MovieRecommendations;
