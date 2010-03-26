From: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Subject: Re: [ewg] How to monitor traffic with IBoE/RoCEE?
Date: Fri, 26 Mar 2010 11:43:02 -0600
Message-ID: <4BACF226.6030201@utah.edu>
References: <4BABFD62.70608@linux.vnet.ibm.com>  <382A478CAD40FA4FB46605CF81FE39F455FF9847@orsmsx507.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <382A478CAD40FA4FB46605CF81FE39F455FF9847-osO9UTpF0URzLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A widely-supported method for collecting statistics from ethernet 
switching devices is SNMP. As Woody said, you wouldn't manage your 
ethernet network any differently than you do now. In addition many many 
tools have been written to make use of SNMP counters, so you won't have 
a hard time finding tools, both commercial and open source.

Tom

On 03/26/2010 11:29 AM, Woodruff, Robert J wrote:
> Pradeep wrote,
>
>    
>> With IBoE/RoCEE, the traditional SM in IB clusters is not needed. Most of the current
>> IB tools rely on the SM and PM to get packet and error statistics and so on. These
>> won't be applicable with IBoE/RoCEE. netstat will have no value since the kernel
>> has been bypassed. So, how does one monitor traffic in such a cluster?
>>      
> Some managed Ethernet switches have the ability to log into them and get information
> on packets transmited/received on each port and errors that are detected. However,
> these are typically proprietary. I am not sure about the Mellanox card.
>
> So I guess the answer is that you manage RoCCE and iWarp clusters just like
> you would any Ethernet cluster, with existing management tools that are available
> for managing Ethernet.
>
> woody
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

-- 
--------------------------------------------------------------------
Tom Ammon
Network Engineer
Office: 801.587.0976
Mobile: 801.674.9273

Center for High Performance Computing
University of Utah
http://www.chpc.utah.edu

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
