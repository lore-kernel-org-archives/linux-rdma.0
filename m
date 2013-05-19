From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Sun, 19 May 2013 09:00:43 +0300
Message-ID: <51986A8B.9030806@mellanox.com>
References: <519686B4.7010300@profitbricks.com> <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com> <5197F447.5020702@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5197F447.5020702-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19/05/2013 00:36, Jack Wang wrote:
> I tried 3.4.23, and mainline kernel from Roland's rdma-for-linus, we
> added bug injection interface,  run multithread iperf, and switched ib
> mode between connected and datagram in sync on each side as Shlomo
> suggested.

Can you be more specific re the  bug injection interface, is that 
existing kernel mechanism or something you added? so the bug triggers 
when you run iperf in multi-threaded mode AND in parallel inject errors 
AND  in parallel switch between datagram and connected mode? bee --- I 
assume this isn't something you do just for the fun of it... so some 
problem X hits you in production and this problem Y you get with the 
above juggling, any known or empiric relation between the two?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
