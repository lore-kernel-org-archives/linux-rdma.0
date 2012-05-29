From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: corrected queue free count math
Date: Tue, 29 May 2012 12:51:01 -0700
Message-ID: <CAL1RGDUqXa49nhdQA+fkjQafaW1tDj44MLWvL5tXVCC9GnuO9A@mail.gmail.com>
References: <40162dc4-2ed3-413b-93bb-34971d08d11c@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <40162dc4-2ed3-413b-93bb-34971d08d11c-nbYkmrCdWxmgMrCBcu8zE0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mahesh.Vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Updated user-kernel abi interface.

Thanks, applied, since this driver hasn't even been in an rc release yet.

But from now on you really need to treat your user-kernel ABI as frozen,
or at least bump your abi version when it changes.  But breaking ABI
is really a pain for users, so please avoid doing it if there's any alternative.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
