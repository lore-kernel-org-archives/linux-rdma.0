From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 6/6] infiniband/nes: Disable ASPM
Date: Fri, 11 Nov 2011 09:31:44 -0800
Message-ID: <CAL1RGDWw7zceDcZZaS7C3YeADR5-py5Roz_CdSeZ4N3yH4uJnw@mail.gmail.com>
References: <1321027511-31229-1-git-send-email-mjg@redhat.com> <1321027511-31229-7-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321027511-31229-7-git-send-email-mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 11, 2011 at 8:05 AM, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The Windows driver .inf disables ASPM on hpsa devices. Do the same.

This isn't a patch to the hpsa driver... cut and paste in the description,
or misfire on the patch?

Faisal, any info on whether this is needed/desired for nes devices
based on Intel's knowledge of the PCIe core used?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
