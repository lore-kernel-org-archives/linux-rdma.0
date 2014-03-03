From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] ipath: Fix potential buffer overrun in sending diag
 packet routine.
Date: Mon, 3 Mar 2014 12:22:08 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211FA846@FMSMSX107.amr.corp.intel.com>
References: <20140217205430.17335.36028.stgit@phlsvslse11.ph.intel.com>
 <20140217210120.17335.50718.stgit@phlsvslse11.ph.intel.com>
 <20140301203028.GJ26071@ngolde.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140301203028.GJ26071-d12P2N94aB+zQB+pC5nmwQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nico Golde <nico-d12P2N94aB+zQB+pC5nmwQ@public.gmane.org>
Cc: Fabian Yamaguchi <fabs-RB2+QK86ijKzQB+pC5nmwQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBXYXMgdGhpcyBwYXRjaCBldmVyIGFjY2VwdGVkIHVwc3RyZWFtPyBJIGRvbid0IHNlZSB0aGlz
IG9uIGdpdC5rZXJuZWwub3JnLg0KPiANCg0KUm9sYW5kIGlzIHRoZSBSRE1BL0lCIG1haW50YWlu
ZXIuDQoNClRoZSB0aW1pbmcgaXMgdXAgdG8gaGltLg0KDQpNaWtlDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
