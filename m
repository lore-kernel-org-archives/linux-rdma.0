From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/1 v2] IB/srp: fix mr allocation when the device
 supports sg gaps
Date: Mon, 2 Jan 2017 08:40:27 +0000
Message-ID: <1483346411.3592.7.camel@sandisk.com>
References: <1482922108-3243-1-git-send-email-maxg@mellanox.com>
         <1482922108-3243-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482922108-3243-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <1DE31847FD00F74D884B06009C6B075A-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE2LTEyLTI4IGF0IDEyOjQ4ICswMjAwLCBNYXggR3VydG92b3kgd3JvdGU6DQo+
IElmIHRoZSBkZXZpY2Ugc3VwcG9ydCBhcmJpdHJhcnkgc2cgbGlzdCBtYXBwaW5nIChkZXZpY2Ug
Y2FwDQo+IElCX0RFVklDRV9TR19HQVBTX1JFRyBzZXQpIHdlIGFsbG9jYXRlIHRoZSBtZW1vcnkg
cmVnaW9ucyB3aXRoDQo+IElCX01SX1RZUEVfU0dfR0FQUy4NCg0KUmV2aWV3ZWQtYnk6IEJhcnQg
VmFuIEFzc2NoZSA8YmFydC52YW5hc3NjaGVAc2FuZGlzay5jb20+
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
