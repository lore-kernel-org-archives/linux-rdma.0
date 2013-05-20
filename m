From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Mon, 20 May 2013 12:05:11 +0300
Message-ID: <5199E747.3070502@mellanox.com>
References: <519686B4.7010300@profitbricks.com> <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com> <5197F447.5020702@profitbricks.com> <51986A8B.9030806@mellanox.com> <519898B0.1000901@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519898B0.1000901-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19/05/2013 12:17, Jack Wang wrote:
> we added inject_bug sysfs node to make function run into error case, like something below. Yes, you are right, we want to speedup the bug reproduce process, and we saw the warning and come to conclusion the neigh->list corrupted some where. What's your opinion?

Yes, for the synthetic experiment you made, there's a possible point here:

Under the CM error flow (e.g your injected error), we delete a 
neighbour, but we also do it from the flow that flush neighbours (e.g 
when changing the device mode from UD to CM, as you did in your script). 
When this happens concurrently, these two code pieces call for deleting 
the neighbour from the list. So the spinlock might not be enough and we 
should have do list_del_init(&neigh->list) instead of list_del, helps?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
