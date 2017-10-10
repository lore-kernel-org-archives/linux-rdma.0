From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 40/47] IB/qib: Make qib_inc_eeprom_err() macro more safe
 to use
Date: Tue, 10 Oct 2017 20:40:42 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC3442BA9E@fmsmsx120.amr.corp.intel.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
         <20171006213333.6721-41-bart.vanassche@wdc.com>
         <32E1700B9017364D9B60AED9960492BC3442AAD2@fmsmsx120.amr.corp.intel.com>
         <1507648081.2815.5.camel@wdc.com>
         <32E1700B9017364D9B60AED9960492BC3442ADF5@fmsmsx120.amr.corp.intel.com>
         <1507658390.2815.48.camel@wdc.com> <20171010180809.GI2106@mtr-leonro.local>
 <1507659918.2815.50.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507659918.2815.50.camel-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiANCj4gU3ViamVjdDogW1BBVENIXSBJQi9xaWI6IFJlbW92ZSByZW1haW5pbmcgY29kZSByZWxh
dGVkIHRvIHdyaXRpbmcgdGhlDQo+IEVFUFJPTQ0KPiANCg0KR28gYWhlYWQgYW5kIHN1Ym1pdCBh
IHYyLg0KDQpJIHdpbGwgZ3JhYiBpdCBmcm9tIHBhdGNod29ya3MgYW5kIHRlc3QuDQoNCk1pa2UN
Cg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
