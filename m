From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2] opensm: Add option to specify prefix to syslog
 messages
Date: Thu, 11 Feb 2010 17:53:34 +0200
Message-ID: <20100211155334.GA26338@me>
References: <4B70F21A.2090101@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B70F21A.2090101-sJ/iWh9BUns@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 21:26 Mon 08 Feb     , Arputham Benjamin wrote:
> Added the option 'log_prefix' that allows users to specify a prefix to
> syslog messages from OpenSM.
> For example, in a dual-fabric (or dual-rail) IB cluster, the prefix for
> the first fabric could be "mpi" and the other fabric could be "storage".
> This helps users to identify the subnet in the syslog messages when
> two or more instances of OpenSM run in a single node to manage multiple
> fabrics.
> 
> Summary of changes:
>  o Added the option 'log_prefix' to OpenSM command line and config file.
>  o Enhanced OpenSM logging facility to include the specified prefix in
>    syslog messages.
> 
> Signed-off-by: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
