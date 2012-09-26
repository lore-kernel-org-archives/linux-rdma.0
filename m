From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Quick mlx4 IB SR-IOV howto?
Date: Wed, 26 Sep 2012 16:11:26 -0400
Message-ID: <5063616E.2020102@dev.mellanox.co.il>
References: <CAL1RGDU0XPCyS6fVeHHxnhLHpREjqi6kjKFCX8hBwrLuVD2HwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDU0XPCyS6fVeHHxnhLHpREjqi6kjKFCX8hBwrLuVD2HwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/26/2012 1:14 PM, Roland Dreier wrote:
> I'm running opensm 3.3.13 on a different box, is that new enough?
> (does SR-IOV require any SM support?)

SRIOV support went into OpenSM 3.3.14. The features for SRIOV are alias
(or virtual) GUID support and some minor partition manager changes (to
allow both full and limited members of same partition on same port).

See
http://git.openfabrics.org/git?p=~alexnetes/opensm.git;a=blob;f=doc/opensm-sriov.txt;h=bbdff48a4cf62398449ea74037e70024208ebc4d;hb=8e6dfbd0b9284fe0083b3f378ec313c3acfb060c

-- Hal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
