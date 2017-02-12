From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
Date: Sun, 12 Feb 2017 20:05:16 +0000
Message-ID: <1486929901.2918.1.camel@sandisk.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
         <20170210235611.3243-9-bart.vanassche@sandisk.com>
         <20170212171928.GF14015@mtr-leonro.local>
         <1041506550.30101266.1486922573298.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1041506550.30101266.1486922573298.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <868902A150620445B2D3A28331F22AB7-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gU3VuLCAyMDE3LTAyLTEyIGF0IDEzOjAyIC0wNTAwLCBMYXVyZW5jZSBPYmVybWFuIHdyb3Rl
Og0KPiBbICA4NjEuMTQzMTQxXSBXQVJOSU5HOiBDUFU6IDI3IFBJRDogMTEwMyBhdCBkcml2ZXJz
L2luZmluaWJhbmQvY29yZS92ZXJicy5jOjE5NTkgX19pYl9kcmFpbl9zcSsweDFiYi8weDFjMCBb
aWJfY29yZV0NCj4gWyAgODYxLjIwMjIwOF0gSUJfUE9MTF9ESVJFQ1QgcG9sbF9jdHggbm90IHN1
cHBvcnRlZCBmb3IgZHJhaW4NCg0KSGVsbG8gTGF1cmVuY2UsDQoNClRoYXQgd2FybmluZyBoYXMg
YmVlbiByZW1vdmVkIGJ5IHBhdGNoIDcvOCBvZiB0aGlzIHNlcmllcy4gUGxlYXNlIGRvdWJsZSBj
aGVjaw0Kd2hldGhlciBhbGwgZWlnaHQgcGF0Y2hlcyBoYXZlIGJlZW4gYXBwbGllZCBwcm9wZXJs
eS4NCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
