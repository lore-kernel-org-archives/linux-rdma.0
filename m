From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: Fix crash on uninitialized priv->cmd.slave_sem
Date: Thu, 27 Sep 2012 10:22:21 +0200
Message-ID: <50640CBD.4060904@mellanox.com>
References: <1348634552-21047-1-git-send-email-roland@kernel.org> <CAJZOPZKoMorYPBqUPbmUcsw1GcXOYo8oE-u2gA6HB6sb3eo1iw@mail.gmail.com> <CAG4TOxPBOMQW1XeB-CNjq+RHix3Rk-ZqfB_6d5YscMQKDOumtA@mail.gmail.com> <506406F4.9030408@mellanox.com> <CAG4TOxPCVuyEUMO01PCUyav+18vMDqN85iSAKc3NWnS3L4PnyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxPCVuyEUMO01PCUyav+18vMDqN85iSAKc3NWnS3L4PnyQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 27/09/2012 10:17, Roland Dreier wrote:
> I think I had it cabled up directly to another HCA, and that HCA was in a
> system that was either off or at least didn't have the driver loaded.  So the
> port was in the physically DOWN state...
>
> However, I just tried it and even with that other HCA enabled (and running
> opensm), I still see
>
>      mlx4_core 0000:05:00.0: Unknown command:0x4d accepted from slave:0
>      mlx4_core 0000:05:00.0: Sense command failed for port: 1
>
> before init_hca finishes, so I think I would have crashed without my patch
> still.  Not sure I understand how you guys miss hitting this fatal call to
> SENSE_PORT during init (or what the intention for SENSE_PORT is
> since right now in SR-IOV mode it always fails due to no wrapper).
>
> I'm not doing anything funny with the port type, I have a one-port CX3
> running FW built with the exact default .ini file, except for enabling SR-IOV.
> And the only mlx4_core module parameter I'm passing in is "num_vfs=1".
>

Thanks for the further details, sounds like something/s is indeed broken 
here, in the code and/or
in the regression testing of it. We'll do our best to provide deeper 
reasoning of what's going on today,
and if not, by Tuesday when Jack is back. This way (your patch) or 
another (some other direction suggested
by the team or Jack) seems we're safe for the merge window.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
