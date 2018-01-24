From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Wed, 24 Jan 2018 22:40:25 +0000
Message-ID: <1516833624.3987.19.camel@wdc.com>
References: <20180123115013.12213-1-leonro@mellanox.com>
         <20180123152142.GB30619@mellanox.com> <1516723456.3339.3.camel@wdc.com>
         <20180123185732.GA1393@mtr-leonro.local> <1516746607.3339.47.camel@wdc.com>
         <1516833393.27592.108.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516833393.27592.108.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <ADEAFDF212B1054481C2240AEBC1D1DD-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE4LTAxLTI0IGF0IDE3OjM2IC0wNTAwLCBEb3VnIExlZGZvcmQgd3JvdGU6DQo+
IENhbiB5b3UgcGxlYXNlIHJlc2VuZCB0aGlzIGFzIGFuIG9mZmljaWFsIHBhdGNoIHdpdGggU09C
IHNvIHdlIGNhbiBwdWxsDQo+IHRoaXMgaW4/ICBUaGFua3MuDQoNCkhlbGxvIERvdWcsDQoNCkNh
biB5b3UgaGF2ZSBhIGxvb2sgYXQgdGhpcyBwYXRjaCBhbmQgc2VlIHdoZXRoZXIgdGhpcyBuZWVk
cyBhbnkgZnVydGhlcg0KYWRqdXN0bWVudHM6IGh0dHBzOi8vbWFyYy5pbmZvLz9sPWxpbnV4LXJk
bWEmbT0xNTE2Nzc2OTcxMjA3NzAuDQoNClRoYW5rcywNCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
