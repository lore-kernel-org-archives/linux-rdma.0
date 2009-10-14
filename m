From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: switching the active interface for bonding
Date: Wed, 14 Oct 2009 13:20:09 +0200
Message-ID: <4AD5B3E9.7070606@voltaire.com>
References: <4AD35909.9020006@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD35909.9020006-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sumeet Lahorani wrote:
> We are using OFED 1.4.2
Please note that the bonding driver provided by the latest distros 
supports IPoIB. So if your distro happen to be RHEL 5.4 (or its OEL 5.4 
derivative), or SLES11 you can and should use the distro provided 
bonding. Moving forward, OTOH customers would use only distro code and 
OTOH bonding will be moved out from ofed, so best  if you better start 
working now as things will be outside anyway.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
