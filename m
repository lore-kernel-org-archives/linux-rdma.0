From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: fprintf stderr in libibverbs
Date: Wed, 28 Oct 2009 15:05:23 -0600
Message-ID: <20091028210523.GN14520@obsidianresearch.com>
References: <20091028054232.GA1966@obsidianresearch.com> <adazl7bs8yt.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adazl7bs8yt.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2009 at 10:51:22AM -0700, Roland Dreier wrote:
> 
>  > My main goal would be to remove prints from the library in common
>  > cases like no IB drivers loaded, no devices present, or no
>  > permissions. I have an app where the prints are inconvient.
>  > 
>  > What I was thinking was to return these cases via errno (ENOSYS,
>  > ENODEV, EPERM) in ibv_get_device_list. Do you think that is OK?
> 
> Yes, that makes sense I guess.

OK, I will see how that looks.
 
>  > int ibv_get_device_list_ex(struct ibv_device ***devices,int *num_devices, 
>  >                            const char **warning_msg);
 
> Are there that many cases where the output is important enough and
> likely enough that it's worth a new API to get it out when stderr
> doesn't suffice?

Looks like just one..

I think we can assume that the sysfs accesses won't fail in real
cases, so those fprintfs are 'uncommon'..

All the ENOMEM cases are also 'uncommon' and could perhaps be fixed up
to return errno (probably not worth the effort)

That leaves these ones:

        dlhandle = dlopen(so_name, RTLD_NOW);
        if (!dlhandle) {
                fprintf(stderr, PFX "Warning: couldn't load driver '%s': %s\n",
                        name, dlerror());

                     fprintf(stderr, PFX "Warning: ignoring bad config directive "
                                "'%s' in file '%s'.\n", field, path);

                fprintf(stderr, PFX "Warning: couldn't open config directory '%s'.\n",
                        IBV_CONFIG_DIR);

                fprintf(stderr, PFX "Warning: RLIMIT_MEMLOCK is %lu bytes.\n"
                        "    This will severely limit memory registrations.\n",
                        rlim.rlim_cur);

                        fprintf(stderr, PFX "Warning: fork()-safety requested "
                                "but init failed\n");

                        fprintf(stderr, PFX "Warning: no userspace device-specific "
                                "driver found for %s\n", sysfs_dev->sysfs_path);

Basically, the only one that tends to occur in common cases is
RLIMIT_MEMLOCK. The rest are environment configuration
problems. (Though I was working with someone with an embedded mthca
and add in mlx4 that was puzzled they had to compile libmthca just to
silence those messages..)

Maybe RLIMIT would be better handled by having apps check errno on
ibv_reg_mr failure and report ENOMEM?

Looks to me like the current code already does, so that is just a doc
update..

Actually, that is something else I was wondering about - the few
functions that return pointers have no documented error code at all,
looks like many (all?) do set errno anyhow - is that a doc oversight
or by design or ??? It would be nice to have err codes come out for
those functions that can fail.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
