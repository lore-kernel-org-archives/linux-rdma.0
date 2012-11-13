From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 00/19, v5] Make ib_srp better suited for H.A. purposes
Date: Tue, 13 Nov 2012 23:35:24 +0100
Message-ID: <50A2CB2C.2080707@acm.org>
References: <508A85BB.1000505@acm.org> <CAJZOPZJPQkJ-kkW3ro9sRJXQJg_Yz_tjoJ1Rwb=XEePO3j_iJw@mail.gmail.com> <50A207D5.6060207@acm.org> <CAJZOPZJXdLRH9NPCt0snGNP8LKODO+phtV7uts6Vj-gxEEjpsw@mail.gmail.com> <50A2BC01.40609@acm.org> <CAJZOPZLQ8B9UGvGdM5LvA6r+XDARO5BXGoMmtdSH6+8EMyMaXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLQ8B9UGvGdM5LvA6r+XDARO5BXGoMmtdSH6+8EMyMaXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/13/12 22:41, Or Gerlitz wrote:
> On Tue, Nov 13, 2012 at 11:30 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>> These attributes have been added to the SRP transport layer. Since the
>> ib_srp driver registers itself with the SRP transport layer the SRP
>> transport layer creates these two attributes for the ib_srp driver. This is
>> similar to how the FC transport layer creates these attributes for FC
>> initiator drivers.
>
> thanks for the heads up... can you provide some pointer please 2-3
> relevant commits and hopefully documentation?  also I recall an
> earlier version of this patch set where you attempted to add to to SRP
> or even on some higher level some probing mechanism which mimics the
> NOPs used by iSCSI, where/how was this ended? does the fact  that
> iscsi has NOPs makes these parameters un-needed where in SRP/FC they
> are?

Hello Or,

Via patch number 16 of this series not only the fast_io_fail_tmo and 
dev_loss_tmo attributes were added to the SRP transport layer but also 
documentation for these attributes was added to 
Documentation/ABI/stable/sysfs-transport-srp. And if you would like to 
have a closer look at the implementation of these attributes for the FC 
initiator transport layer, you can find it in 
drivers/scsi/scsi_transport_fc.c.

The code for sending a TUR periodically that was present in a previous 
version of this patch series has been dropped because it's not a proper 
transport layer test. As far as I know there is no equivalent for iSCSI 
NOPs in the SRP protocol. There might be an appropriate equivalent in 
the IB RC layer but I haven't started looking into that yet.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
