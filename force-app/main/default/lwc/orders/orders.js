import { LightningElement, api } from 'lwc';
import getSumOrdersByAccount from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';

export default class Orders extends LightningElement {
    @api recordId;
    sumOrdersOfCurrentAccount = 0;

    connectedCallback() {
        console.time('Total fetchSumOrders()'); // début mesure totale
        this.fetchSumOrders();
    }

    fetchSumOrders() {
        if (this.recordId) {
            console.time('Appel Apex getSumOrdersByAccount');
            getSumOrdersByAccount({ accountId: this.recordId })
                .then(result => {
                    console.timeEnd('Appel Apex getSumOrdersByAccount');

                    console.time('Traitement JS résultat');
                    this.sumOrdersOfCurrentAccount = result;
                    console.timeEnd('Traitement JS résultat');

                    console.timeEnd('Total fetchSumOrders()');
                })
                .catch(error => {
                    console.error('Erreur lors de la récupération des commandes : ', error);
                    this.sumOrdersOfCurrentAccount = 0;

                    console.timeEnd('Appel Apex getSumOrdersByAccount');
                    console.timeEnd('Total fetchSumOrders()');
                });
        } else {
            console.warn('recordId non défini');
            this.sumOrdersOfCurrentAccount = 0;
            console.timeEnd('Total fetchSumOrders()');
        }
    }

    get hasError() {
        return !this.sumOrdersOfCurrentAccount || this.sumOrdersOfCurrentAccount <= 0;
    }
}
