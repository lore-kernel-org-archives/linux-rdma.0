From: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: Linux DMA address
Date: Tue, 3 Jul 2012 15:37:41 +0200
Message-ID: <OF2C9BED9D.50BF4649-ONC1257A30.004A568D-C1257A30.004ADEF1@de.ibm.com>
References: <OF0BBAC7B2.370E3DEF-ONC1257A2F.003DED12-C1257A2F.00407B62@de.ibm.com> <4FF1A7F0.10208@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FF1A7F0.10208-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
thanks for your quick answer.
Let me stress this once again...
1.) Is it possible/allowed to call ib_dma_map_single() on Linux, same
buffer address, size and dma_data direction, for two different ib devic=
es?
=46or the data transmission we will have controls in place that not bot=
h
devices write at the same time into that buffer.
2.) If this is possible, will the returned dma_addresses be the same? A=
ny
dependencies on the adapter model?

Any thoughts on this? Thanks.
Kind regards
Klaus Wacker
IBM Systems &Technology Group, Systems Software Development
SW Linux on System z Dev & Service
Phone:  +49-7031-16-3779   IBM Deutschland  E-Mail:  kdwacker-tA70FqPdS9Zhl2p70BpVqQ@public.gmane.org=
m
Schoenaicher Str. 220   71032 Boeblingen   Germany
IBM Deutschland Research & Development GmbH / Vorsitzende des
Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen / Registergericht: Amtsgericht Stutt=
gart,
HRB 243294


|------------>
| From:      |
|------------>
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
  |Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>                                  =
                                                                       =
       |
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
|------------>
| To:        |
|------------>
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
  |Klaus Wacker/Germany/IBM@IBMDE,                                     =
                                                                       =
       |
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
|------------>
| Cc:        |
|------------>
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
  |<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>                                        =
                                                                       =
       |
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
|------------>
| Date:      |
|------------>
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
  |02/07/2012 15:54                                                    =
                                                                       =
       |
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
|------------>
| Subject:   |
|------------>
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|
  |Re: Linux DMA address                                               =
                                                                       =
       |
  >--------------------------------------------------------------------=
-----------------------------------------------------------------------=
-------|





On 7/2/2012 2:44 PM, Klaus Wacker wrote:
> [...] So whats the nature of the returned DMA address of
ib_dma_map_single and can we
> assume that it is the same value on different devices on one system?

Currently, over all IB drivers/devices except for ipath and qib,
ib_dma_map_single is just plain dma_map_single, so your questions
relates directly to the Linux DMA mapping API (and BTW - the answer is
YES, in the general case you must use a DMA address you were provided
when calling dma_map_single with device being X only for transactions
carried over X). For those devices that hack ib_dma_map_single, it migh=
t
be possible to use address provided from device X over device Y, but
this is a hack, and I would strongly recommend not to have it in you co=
de.

Or.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
