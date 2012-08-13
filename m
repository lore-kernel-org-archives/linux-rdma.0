From: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: check iboe netdev pointer before dereferencing
 it
Date: Mon, 13 Aug 2012 10:17:26 -0300
Message-ID: <5028FE66.10705@linux.vnet.ibm.com>
References: <1344623134-22600-1-git-send-email-klebers@linux.vnet.ibm.com> <502743CE.2070502@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <502743CE.2070502-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/12/2012 02:49 AM, Or Gerlitz wrote:

> On 10/08/2012 21:25, Kleber Sacilotto de Souza wrote:
>> This patch fixes the problem by checking for a valid netdev pointer
>> before using it to get the port MAC address.
> 
> just curious, how did you actually stepped on this, code inspection or
> any actual race?
> 
> Or.
> 


I hit the problem during error recovery after injecting an EEH error on
a distro kernel based on linux 3.0. I was not able to reproduce the
problem on the mainline kernel, but it seems to be just a matter of
having the right timing.

-- 
Kleber Sacilotto de Souza
IBM Linux Technology Center

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
