From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] infiniband-diags: add rdma-ndd daemon
Date: Mon, 10 Nov 2014 00:28:27 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CBA8FCD@CRSMSX101.amr.corp.intel.com>
References: <1414713270-12710-1-git-send-email-ira.weiny@intel.com>
 <1414713270-12710-2-git-send-email-ira.weiny@intel.com>
 <20141108004029.GB12120@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141108004029.GB12120-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> Sadly, I think the proper way to address this is the same way netdev addresses
> it - do not activate the interface on module load, wait for an explicit
> enablement so userspace can configure before it tries to link up.
> 
> (Not to say that is even possible considering RDMA's history, but still..)

I don't think this is really possible.  When would you consider the "interface" to be "up"?  Even before the port goes active the SM and other diags can query this value.  This is why I propose that the default of the drivers, without user space involvement, should change.  The user space daemon is only trying to react to other user space activity.

> 
> TBH, I'd rather see just this daemon and drop the kernel side... If the daemon is
> started before the modules are loaded then it might be able to set the
> description while the port is still down.

The problem is this sequence.

1) rdma-ndd daemon started (hostname == localhost, no rdma devices set)
2) dhcp started (or other hostname change, rdma-ndd triggered but no rdma devices set; not loaded yet)
3) rdma devices loaded, default node_desc

What I have proposed will work no matter what order things are started/loaded.  Furthermore, it avoids races between the start up scripts and the SM because the current hostname is always mapped at the time the query is being answered.  With parallel start up systems like systemd you could have the hostname set by DHCP while some of your rdma devices are loaded and others are not.  Those which were loaded before the hostname change will get set by rdma-ndd and trigger a trap.  The others will simply pick up the correct hostname in the initial SM query.

Finally, I contemplated the alternative of having the rdma-ndd daemon detect new rdma devices.  I don't like this solution because it results in additional unnecessary MAD traffic for those devices.  (ie. initial ND query, followed by a trap/trap repress, and the final "correct" ND query.)  With my proposed solution any devices loaded after the hostname change (or in the case of a static hostname) will be properly queried with one ND query.

-- Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
