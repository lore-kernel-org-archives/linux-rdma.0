From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 06/11] RDMA/nes: abnormal listener termination causes
 loopback node crash
Date: Thu, 10 Dec 2009 03:44:32 -0700
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE40FB9E82@azsmsx501.amr.corp.intel.com>
References: <20091209224115.GA128120@flatif-MOBL>
 <4B20A00C.1070607@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B20A00C.1070607-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Faisal Latif wrote:
>> when listener is destroyed for loopback connection

>Does the upstream iwarp stack supports loopback connections?

Yes.

> does it apply to all vendors?

Yes but Chelsio handles loopback differently from Intel/NetEffect.

This topic came up before, see:

http://lists.openfabrics.org/pipermail/general/2009-July/060542.html

http://lists.openfabrics.org/pipermail/general/2009-July/060548.html


Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
