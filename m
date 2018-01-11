From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Thu, 11 Jan 2018 21:15:42 +0000
Message-ID: <1515705340.2752.60.camel@wdc.com>
References: <1515531652.26021.1.camel@redhat.com>
         <1515537614.26021.3.camel@redhat.com> <1515591723.26021.6.camel@redhat.com>
         <20180110182648.GI4518@ziepe.ca> <1515609623.2745.20.camel@wdc.com>
         <1515610750.10153.1.camel@redhat.com> <20180110191510.GK4518@ziepe.ca>
         <1515612639.10153.3.camel@redhat.com> <20180110205243.GP4776@mellanox.com>
         <1515618674.10153.6.camel@redhat.com> <20180110211501.GS4776@mellanox.com>
         <1515675741.21421.1.camel@redhat.com> <1515703435.21421.9.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515703435.21421.9.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <A9BA054FB3DCB14994D4C3925797EC3C-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE4LTAxLTExIGF0IDE1OjQzIC0wNTAwLCBMYXVyZW5jZSBPYmVybWFuIHdyb3Rl
Og0KPiBTZXJ2ZXIgbG9nDQo+IC0tLS0tLS0tLS0NCj4gTGludXggZmVkc3RvcmFnZS5ib3MucmVk
aGF0LmNvbSA0LjE1LjAtcmM3LmJhcnQrICMxIFNNUCBUaHUgSmFuIDExDQo+IDE0OjE3OjMzIEVT
VCAyMDE4IHg4Nl82NCB4ODZfNjQgeDg2XzY0IEdOVS9MaW51eA0KPiBbcm9vdEBmZWRzdG9yYWdl
IH5dIyBbICA1MzMuNDA1MjkxXSBJUHY2OiBBRERSQ09ORihORVRERVZfQ0hBTkdFKTogaWIwOiBs
aW5rIGJlY29tZXMgcmVhZHkNCj4gWyAgNTMzLjQ0Mjg4NF0gSVB2NjogQUREUkNPTkYoTkVUREVW
X0NIQU5HRSk6IGliMTogbGluayBiZWNvbWVzIHJlYWR5DQo+IFsgIDU0MC4wMjQ0MzhdIGliX3Ny
cHQgUmVjZWl2ZWQgU1JQX0xPR0lOX1JFUSB3aXRoIGlfcG9ydF9pZCA3Y2ZlOjkwMDM6MDA3Mjo2
ZTRlOjdjZmU6OTAwMzowMDcyOjZlZDIsIHRfcG9ydF9pZCA3Y2ZlOjkwMDM6MDA3Mjo2ZTRlOjdj
ZmU6OTAwMzowMDcyOjZlNGUgYW5kIGl0X2l1X2xlbiAyMTE2IG9uIHBvcnQgMQ0KPiAoZ3VpZD1m
ZTgwOjAwMDA6MDAwMDowMDAwOjdjZmU6OTAwMzowMDcyOjZlNGUpOyBwa2V5IDB4ZmZmZg0KPiBb
ICA1NDAuMTQxNDY0XSBpYl9zcnB0IGZhaWxlZCB0byBjcmVhdGUgcXVldWUgcGFpciB3aXRoIHNx
X3NpemUgPSAxNjM4NCAoLTEyKSAtIHJldHJ5aW5nDQo+IFsgIDU0MC4xODYxNTldIGliX3NycHQg
ZmFpbGVkIHRvIGNyZWF0ZSBxdWV1ZSBwYWlyIHdpdGggc3Ffc2l6ZSA9IDgxOTIgKC0xMikgLSBy
ZXRyeWluZw0KPiBbICA1NDAuMjMxNzk0XSBpYl9zcnB0IFJlamVjdGVkIGxvZ2luIGZvciBpbml0
aWF0b3IgN2NmZTo5MDAzOjAwNzI6NmVkMjogcmV0ID0gLTEzLg0KPiBbICA1NDAuMjc0MDc3XSBp
Yl9zcnB0IFJlamVjdGluZyBsb2dpbiB3aXRoIHJlYXNvbiAweDEwMDA2DQoNCkhlbGxvIExhdXJl
bmNlLA0KDQpJIHRoaW5rIHRoYXQgbWVhbnMgdGhhdCBubyBBQ0wgd2FzIGNvbmZpZ3VyZWQgb24g
dGhlIHRhcmdldCBzaWRlIGZvcg0KaW5pdGlhdG9yIHBvcnQgN2NmZTo5MDAzOjAwNzI6NmVkMi4g
Q2FuIHlvdSBwcm92aWRlIHRoZSBvdXRwdXQgb2YNCihjZCAvc3lzL2tlcm5lbC9jb25maWcvdGFy
Z2V0L3NycHQgJiYgbHMgLWQgKi8qL2FjbHMvKik/DQoNClRoYW5rcywNCg0KQmFydC4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
