From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Native IB connection setup.
Date: Thu, 2 Jan 2014 13:10:47 +0200
Message-ID: <52C54937.7020003@mellanox.com>
References: <CAKxz9HDpu6-R8HbP6kFw1TU-Px-vrGOB7JVOTdRAFyXiDTdKjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKxz9HDpu6-R8HbP6kFw1TU-Px-vrGOB7JVOTdRAFyXiDTdKjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ilya Kalistru <stebanoid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/2/2014 10:11 AM, Ilya Kalistru wrote:
> Happy New Year, ladies and gentlemen!
>
> I'm developing some sort of "hardware InfiniBand server" runing on
> FPGA and delivering some data to PC using RDMA_WRITE operation.
> I've already had Physical Link Up and Logical Link Up between my
> device and PC with Mellanox HCA.
> I see GUID and LID of my device when I runing ibstatus or
> ibnetdiscover command on PC and therefore I think subnet configuration
> is ok.
>
> Now I have a problem with connection setup. Because I'm only who is
> developing this device and it's a problem to add extra protocols in
> FPGA firmware I don't want to use any something like getaddrinfo()
> (they use IPoIB)...
> I'm going to use native IB CM REQ/REP/RTU MADs for connection setup,
> but I don't know how.
>
> I think that I should request GUID to LID resolution at first. Like
> rdma_resolve_addr()/rdma_resolve_route() but from GUID not from IP.
> Second (I think) I should use ib_send_cm_req() and ib_send_cm_rtu()
> with well known ServiceID (I select it) to establish connection.
>
> I'm not a programmer and have no experience with programming of
> network based applications and therefore I will be thankful very much
> if you help me with example of programm code using native IB
> connection setup technics or any other help.

You can  have a look in SRP (SCSI RDMA Protocol under 
drivers/infiniband/ulp/srp) as a reference for native IB connection 
establishment.

> P.S. It's my first time I'm using mailing list. I'm sorry, if I'm
> doing something wrong.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message tomajordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
