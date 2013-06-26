From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 10/15 ibacm] Add the ability to preload the destination
 GID and LID caches
Date: Wed, 26 Jun 2013 18:46:32 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD36F65@ORSMSX109.amr.corp.intel.com>
References: <51C432BC.9020706@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A823736FD36C84@ORSMSX109.amr.corp.intel.com>
 <51CAC70D.5000205@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CAC70D.5000205-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> To preload these caches, ibacm service is started with -p option
> >> which can also take optional path_rec_file which defaults to
> >> ACM_CONF_DIR/ibacm_path_records.dump
> >
> > I would rather use the config file versus adding command line parameters.
> 
> So add a new preload option in the config file for this ?

Please add entries in the config file that can be used to specify the names of the data files.
 
> > This series will preload the cache, but it does not change the actual
> protocol ibacm uses for updates.
> > I want to verify that this is your intent.
> 
> Yes, that is my intent.
> 
> > I see within this patch that you override the address and route timeout
> values set by the user.
> > I think the code should honor those settings.
> 
> OK. The user can configure no address and/or route timeout if that is
> what he wants so this mode of operation is possible currently without this.
> 
> > I wonder if it would make sense to treat file loading as a 'protocol' rather
> than a preload of the cache.
> > By changing the timeout value, this is essentially what occurs.
> 
> Didn't you just write above not to change those timeout values ?

My preference is that the timeout values not be changed.  I was commenting that since the patch did change the timeout values, it essentially disabled the protocols used for updating the cache.
 
> > One drawback I see with using this as a simple preload mechanism is that the
> entire cache would timeout at once if cache timeouts are enabled.
> 
> You're talking about the way it works as currently proposed in this
> patch, right ?

I was talking about the proposed patch, but removing the change to the timeout.

For this series, please remove the timeout changes and treat the changes as you intended, which is to simply preload the cache.  If we ever want to update the cache by reading from a file, that can come as a separate change.

Thanks,
- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
