From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RE-RESEND V2 for-next 4/5] IB/core: Make sure that the
 PSN does not overflow
Date: Mon, 16 Feb 2015 22:06:07 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC282FF@CRSMSX101.amr.corp.intel.com>
References: <1423137232-24587-1-git-send-email-ogerlitz@mellanox.com>
	 <1423137232-24587-5-git-send-email-ogerlitz@mellanox.com>
 <1424121752.32606.32.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424121752.32606.32.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQo+IA0KPiAweGZmZmZmZiBjb3VsZCBiZSBtYWRlIGEgI2RlZmluZQ0KPiANCj4gUXVlc3Rpb246
IHVzZXJzcGFjZSBpcyBhbGxvd2VkIHRvIGFzayBmb3IgYSBQU04gb24gMzJiaXRzLCBidXQgaXQg
d2lsbCBiZSBzaWxlbnRseQ0KPiB0cnVuY2F0ZWQsIGlzIGl0IGdvaW5nIHRvIHB1enpsZSBhcHBs
aWNhdGlvbnMgPw0KPiANCj4gQW55d2F5LCBpdCB3b3VsZCBoYXZlIGJlZW4gYmV0dGVyIHRvIHJl
dHVybiBhbiBlcnJvciBpbiB0aGUgZmlyc3QgcGxhY2UgLi4uIG5vdA0KPiBzdXJlIGlmIHdlIGNh
biBkbyBpdCBub3cgLi4uDQo+IA0KDQpZZXMgSSdtIHN0aWxsIG5vdCBzdXJlIHdoYXQgYnVnIHRo
aXMgZml4ZXMuICBPciBkaWQgeW91IGV2ZXIgZmluZCBvdXQ/DQoNCklyYQ0KIA0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
