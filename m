From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] ib_srpt: use kvmalloc to allocate ring pointers
Date: Mon, 9 Jul 2018 20:56:47 +0000
Message-ID: <130534ba53f2ddba125896834ee34099fa164174.camel@wdc.com>
References: <1531144268-25361-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531144268-25361-1-git-send-email-jan.dakinevich@virtuozzo.com>
Content-Language: en-US
Content-ID: <E5C2F60B545A7B498F6BD3F00546D396@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "jan.dakinevich@virtuozzo.com" <jan.dakinevich@virtuozzo.com>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "khorenko@virtuozzo.com" <khorenko@virtuozzo.com>, "den@virtuozzo.com" <den@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE4LTA3LTA5IGF0IDE2OjUxICswMzAwLCBKYW4gRGFraW5ldmljaCB3cm90ZToN
Cj4gQW4gYXJyYXkgb2YgcG9pbnRlcnMgdG8gU1JQVCBjb250ZXh0cyBpbiBpYl9kZXZpY2UgaXMg
b3ZlciAzMEtpQiBldmVuDQo+IGluIGRlZmF1bHQgY2FzZSwgaW4gd2hpY2ggYW4gYW1vdW50IG9m
IGNvbnRleHRzIGlzIDQwOTUuIFRoZSBwYXRjaA0KPiBpcyBpbnRlbmRlZCB0byB3ZWVkIG91dCBs
YXJnZSBjb250aWdvdXMgYWxsb2NhdGlvbiBmb3Igbm9uLURNQSBtZW1vcnkuDQoNClJldmlld2Vk
LWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJhcnQudmFuYXNzY2hlQHdkYy5jb20+DQoNCg0KDQoNCg==
