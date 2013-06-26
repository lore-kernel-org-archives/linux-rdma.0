From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 10/15 ibacm] Add the ability to preload the destination
 GID and LID caches
Date: Wed, 26 Jun 2013 06:48:45 -0400
Message-ID: <51CAC70D.5000205@dev.mellanox.co.il>
References: <51C432BC.9020706@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A823736FD36C84@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD36C84-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/25/2013 7:41 PM, Hefty, Sean wrote:
>> Preloading of these caches is supported via a file which is
>> produced by OpenSM by the dump_pr plugin which contains
>> sufficient SA PathRecord information. Details on this
>> file format and configuring OpenSM for this are found in
>> dump_pr_notes.txt in dump_pr.
>>
>> File format is specified in ibacm_opts.cfg as follows:
>> path_rec_fnt full_opensm_v1
>>
>> To preload these caches, ibacm service is started with -p option
>> which can also take optional path_rec_file which defaults to
>> ACM_CONF_DIR/ibacm_path_records.dump
> 
> I would rather use the config file versus adding command line parameters.

So add a new preload option in the config file for this ?

> This series will preload the cache, but it does not change the actual protocol ibacm uses for updates.   
> I want to verify that this is your intent.

Yes, that is my intent.

> I see within this patch that you override the address and route timeout values set by the user.  
> I think the code should honor those settings.

OK. The user can configure no address and/or route timeout if that is
what he wants so this mode of operation is possible currently without this.

> I wonder if it would make sense to treat file loading as a 'protocol' rather than a preload of the cache.  
> By changing the timeout value, this is essentially what occurs.  

Didn't you just write above not to change those timeout values ?

> If the cached data can timeout, then there's an option for what ibacm should do.  If it falls back to its
configured
> address/route protocols, then this is truly a preload of the cache.

That's what would happen now (for node not in cache or on timeout).

> An alternate option would be for ibacm to see if the input files 
> had been updated, and if so, reload its cache.

Yes, that seems like another valid alternative.

> One drawback I see with using this as a simple preload mechanism is that the entire cache would timeout at once if cache timeouts are enabled.

You're talking about the way it works as currently proposed in this
patch, right ?

-- Hal

> - Sean
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
