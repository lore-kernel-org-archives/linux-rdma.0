From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: QoS in local SA entity
Date: Tue, 10 Nov 2009 07:29:38 +0200
Message-ID: <4AF8FA42.4000905@voltaire.com>
References: <4AF2C00A.4040808@voltaire.com>	<9BF1CEFA7F6F44F5B5641065C4914EB5@amr.corp.intel.com>	<4AF66473.2050303@voltaire.com> <5C9CD47F123648F0A926E151BF775484@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5C9CD47F123648F0A926E151BF775484-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> [...] The current implementation of ACM converts this to:
> 	** Source sends a multicast request to destination IP
> 	** Destination sends a response with IP to DGID mapping
> 	- Path record is constructed from multicast group information	
> ACM needs to know what the local addresses are, so it can respond to requests
> for those addresses
okay got it. Still, how do you see my suggestion on the unified/modified 
librdmacm flow (L1/L2/L3 in my email) which would be taken when working 
against a "DGID/Route" provider such as ACM?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
