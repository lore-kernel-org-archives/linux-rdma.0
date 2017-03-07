From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/2] device: Stop requiring that struct device is
 embedded in struct pci_dev
Date: Tue, 7 Mar 2017 05:13:28 +0000
Message-ID: <1488863593.2997.3.camel@sandisk.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
         <20170307003549.3872-2-bart.vanassche@sandisk.com>
         <20170307045236.GC3913@kroah.com>
         <VI1PR0502MB3008BEC2FB8747DDA40A10FCD12F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008BEC2FB8747DDA40A10FCD12F0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Content-ID: <C7B734AEBC7A9D44980C8D3FA44953D1-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org" <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE3LTAzLTA3IGF0IDA1OjA4ICswMDAwLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+
IEkgcmVwbGllZCB3aXRoIHBzZXVkbyBjb2RlIGluIHByZXZpb3VzIHJlcGx5IHRvIEJhcnQgdG8g
YnJpbmcgYmFjayBkbWFfZGV2aWNlIG1lbWJlciBpbiB0aGUgaWJfZGV2aWNlLg0KPiBkbWFfZGV2
aWNlIG1lbWJlciB3YXMgYWxyZWFkeSBwcmVzZW50IGluIG5lYXIgcGFzdCBvZiBmZXcgd2Vla3Mu
DQo+IEl0IHNob3VsZCBiZSBhYmxlIHRvIHdvcmsgdXNpbmcgaXQgd2l0aG91dCBwZXJmb3JtYW5j
ZSBpbXBhY3QgYW5kIHdpdGhvdXQgdG91Y2hpbmcgZHJpdmVyIGNvcmUgbGF5ZXIgbGlrZSBpbiB0
aGlzIHBhdGNoLg0KDQpUaGF0J3MgY29uZnVzaW5nIGFuZCB3YXMgYSBzb3VyY2Ugb2YgYnVncyBh
bmQgaW5jb25zaXN0ZW5jaWVzLiBXZSBkbyBub3QNCndhbnQgdHdvIGRldmljZSBzdHJ1Y3R1cmVz
IGluIHN0cnVjdCBpYl9kZXZpY2UgKHN0cnVjdCBkZXZpY2UgZGV2IGFuZCBzdHJ1Y3QNCmRldmlj
ZSAqZG1hX2RldmljZSkuDQoNCkJhcnQu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
