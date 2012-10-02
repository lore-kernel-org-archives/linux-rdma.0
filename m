From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] mlx4_core: Disable SENSE_PORT for multifunction devices
Date: Tue, 2 Oct 2012 10:52:56 +0200
Message-ID: <201210021052.57154.jackm@dev.mellanox.co.il>
References: <1348768037-3660-1-git-send-email-roland@kernel.org> <1348768037-3660-3-git-send-email-roland@kernel.org> <CAJZOPZLSBk0GEK-8SCAoXR0qCzpG9_P5nrWcWJ-vhcnKZAKvjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLSBk0GEK-8SCAoXR0qCzpG9_P5nrWcWJ-vhcnKZAKvjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday 27 September 2012 22:58, Or Gerlitz wrote:
> On Thu, Sep 27, 2012 at 7:47 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> >
> > In the current driver, the SENSE_PORT firmware command is issued as a
> > "wrapped" command, but the command handling code doesn't have a
> > wrapper, so it will never do anything other than log an error message.
> > The latest ConnectX-3 2.11.500 firmware reports the SENSE_PORT
> > capability even in multi-function (SR-IOV) mode, so the driver will
> > try to issue the command.
> >
> > At least until the driver has a proper wrapper for SENSE_PORT, make
> > sure we disable the command for multi-function devices.
> 
> makes sense, nice doing!
> 
> Acked-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> for patches 1-3
> 
> Roland, I see that these three patches are queued @ your for-next and
> also the initial
> patch which in a way is more lengthy and heavy.  I wonder whether
> wouldn't it be fare to allow for Jack to review it before pushing?
> Jack is back by Tuesday.
>
Acked-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> for patches 1-3

Nice going, Roland!

-Jack

> Or.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
