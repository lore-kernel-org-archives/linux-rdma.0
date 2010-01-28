From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: DREQ timeout for rdma-cm consumers
Date: Thu, 28 Jan 2010 15:03:59 +0200
Message-ID: <4B618B3F.9030803@voltaire.com>
References: <Pine.LNX.4.64.1001261749260.13804@zuben.voltaire.com> <F766FA8B1AD74F0E98EF28981448A4CF@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F766FA8B1AD74F0E98EF28981448A4CF-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> I believe that the IB timeout of 20 is about 4 seconds.  If the packet lifetime is 1 second, then each try will take 6 seconds to timeout.  For 15 retries, this is close to 100 seconds.  
okay, thanks for explaining this.

> You should be able to destroy the rdma_cm_id at anytime
I understand that, however, currently the code I am working with (iser) 
wait to get both flushes on all the posted work requests AND disconnect 
or address-change event to mark the <rdmacm id, qp> couple as 
disconnected, clear it up and signal higher level to reconnect. I'll 
have to look what is the way to go for fast reconnection, maybe connect 
a new <id, qp> couple before the current one is totally 
flushed/disconnected. Also, destroying the ID doesn't remove the qpn 
from the IB CM timewait database, correct? hence if I don't wait long 
enough and the driver/hw reuses the qpn short enough to hit the IB CM 
stale connection/etc logic, I will not be able to reconnect, I guess.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
