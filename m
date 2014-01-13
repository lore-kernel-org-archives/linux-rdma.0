From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Question about CPU-HCA interaction
Date: Mon, 13 Jan 2014 04:04:04 -0500
Message-ID: <CADPSxAht4-xBBn0UtNV5PzZxH1qHF0f7VN6TK9vWbEMB8mpa5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi.

I wanted to understand the PCIe usage while issuing Infiniband verbs.
When posting a verb to a queue pair, how is the request descriptor
written to the HCA? IMO, there are two options for this:

1. CPU prepares the descriptor in local memory. After preparing the
descriptor, it writes the location of the descriptor to a hardwired
register on the HCA (this process is called "ringing the doorbell"?).
The HCA then reads the descriptor via DMA.

2. The CPU writes the entire descriptor to the HCA's memory via PCIe
MMIO. Then, it rings the doorbell to alert the HCA.

To me, the first one makes more sense, but I'm not sure. It would be
great if someone could tell more about this.

Thanks for your help.

--Anuj
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
