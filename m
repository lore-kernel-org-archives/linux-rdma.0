From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: Proposal to add a name to an IB subnet
Date: Sun, 20 Dec 2009 14:43:23 +0200
Message-ID: <20091220124323.GH5262@me>
References: <4B16FF44.7090507@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B16FF44.7090507-sJ/iWh9BUns@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 15:59 Wed 02 Dec     , Arputham Benjamin wrote:
> 
> We could add an option '-n | --ib_subnet_name' to OpenSM command line
> to input the IB subnet name and modify the osm_log() function for syslog
> messages (message type: OSM_LOG_SYS) to prefix its messages with the
> subnet name. 
> 
> Also, we could limit this name prefix changes to syslog messages only for now.
> (i.e., leave the opensm log as it is because the current implementation
> allows the user to specify the file name for the opensm log)
> 
> Any comments?

Looks like a nice idea for me.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
