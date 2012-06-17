From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: rsockets and other performance
Date: Sun, 17 Jun 2012 14:20:39 -0700
Message-ID: <4FDE4A27.5080601@linux.vnet.ibm.com>
References: <4FDA0233.6090409@linux.vnet.ibm.com> <1339690194.14317.5.camel@oc1677441337.ibm.com> <4FDD85B3.2090406@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FDD85B3.2090406-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kashyapv-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/17/2012 12:22 AM, Or Gerlitz wrote:
> On 6/14/2012 7:09 PM, Sridhar Samudrala wrote:
>> Enabling NETIF_F_SG improves the throughput further by avoiding a 
>> additional kernel memcpy caused by skb_linearize() in dev_queue_xmit().
>
> Hi Sridhar,
>
> If you **only** enable NETIF_F_SG for CM, does this yields any gain? 
> did you had to patch the code for that end?
>
Hi Or, We did not try only NETIF_F_SG for IPoIB CM. We tried it along 
with NETIF_F_IP_CSUM. We did run
into issues  with netperf i.e. netperf errors out  along with 
NETIF_F_SG. However, iperf worked fine. Did not investigate that further.

Thanks
Pradeep


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
