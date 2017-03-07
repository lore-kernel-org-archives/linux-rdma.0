From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/2] device: Stop requiring that struct device is
 embedded in struct pci_dev
Date: Tue, 7 Mar 2017 02:44:28 +0000
Message-ID: <1488854653.2997.1.camel@sandisk.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
         <20170307003549.3872-2-bart.vanassche@sandisk.com>
         <VI1PR0502MB3008D3B38ED2F3694E100E5ED12F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <VI1PR0502MB3008D3B38ED2F3694E100E5ED12F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Content-Language: en-US
Content-ID: <8AC8022639709244963BFC8F43B5D66D@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "parav@mellanox.com" <parav@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sebott@linux.vnet.ibm.com" <sebott@linux.vnet.ibm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "dwmw2@infradead.org" <dwmw2@infradead.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE3LTAzLTA3IGF0IDAyOjQxICswMDAwLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+
IENvbXBpbGF0aW9uIHdvdWxkIGJyZWFrIHdoZW4gQ09ORklHX1BDSSBpcyBub3QgZGVmaW5lZCBm
b3Igc29tZSBlbWJlZGRlZCBwbGF0Zm9ybXMuDQo+IE1vcmUgdGhhbiB0aGF0LCBpbmNsdWRpbmcg
c3BlY2lmaWMgcGNpX2RldiBzdHJ1Y3R1cmUgcG9pbnRlciBpbiBnZW5lcmljIHN0cnVjdHVyZSBz
dWNoIGFzIGRldmljZSBqdXN0IGRvZXNuJ3Qgc291bmQgcmlnaHQuDQo+IEkgdGVzdGVkIGVxdWl2
YWxlbnQgcGF0Y2ggdGhhdCB5b3Ugc2VudCwgYnV0IEkgZG9uJ3QgdGhpbmsgdGhpcyBpcyByaWdo
dCBkaXJlY3Rpb24gdG8gZml4IHRoaXMgYnVnLg0KDQpZb3UgYXJlIHdlbGNvbWUgdG8gdm9pY2Ug
eW91ciBvcGluaW9uLiBCdXQgdW5sZXNzIGFueW9uZSBwcm9wb3NlcyBhIGJldHRlcg0KYWx0ZXJu
YXRpdmUgSSBwcm9wb3NlIHRvIHByb2NlZWQgd2l0aCB0aGlzIGFwcHJvYWNoLg0KDQpCYXJ0Lg==
