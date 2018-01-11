From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH] RDMA/rxe: Fix a race condition related to the QP error
 state
Date: Thu, 11 Jan 2018 16:02:33 +0000
Message-ID: <1515686552.2752.2.camel@wdc.com>
References: <20180109192340.25702-1-bart.vanassche@wdc.com>
         <1515620434.3403.169.camel@redhat.com>
         <1515621700.3403.174.camel@redhat.com>
         <20180111062252.GP7368@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111062252.GP7368-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <714CAA657664B24B98AE652264A120FC-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE4LTAxLTExIGF0IDA4OjIyICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IFRoZSBwcm9wb3NlZCBwYXRjaCBkZWZpbml0ZWx5IGRlY3JlYXNlcyB0aGUgY2hhbmNlIG9m
IHJhY2VzLCBidXQgaXQgaXMgbm90IGZpeGluZyB0aGVtLg0KPiBUaGVyZSBpcyBhIGNoYW5jZSB0
byBoYXZlIGNoYW5nZSBpbiBxcCBzdGF0ZSBpbW1lZGlhdGVseSBhZnRlciB5b3VyICJpZiAuLi4i
IGNoZWNrLg0KDQpIZWxsbyBMZW9uLA0KDQpQbGVhc2UgaGF2ZSBhIGxvb2sgYXQgcnhlX3FwX2Vy
cm9yKCkgYW5kIHlvdSB3aWxsIHNlZSB0aGF0IHRoZSBwYXRjaCBJIHBvc3RlZA0KaXMgYSBwcm9w
ZXIgZml4LiBJbiB0aGUgc2NlbmFyaW8geW91IGRlc2NyaWJlZCByeGVfcXBfZXJyb3IoKSB3aWxs
IHRyaWdnZXIgYQ0KcnVuIG9mIHJ4ZV9jb21wbGV0ZXIoKS4NCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
