From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB SR-IOV
Date: Tue, 13 Aug 2013 09:56:51 +0300
Message-ID: <5209D8B3.7030309@mellanox.com>
References: <CAKY8vKrJ=BDOKd5hnZjiS7XO_u-Sz+PsOuymaDxJbHBP2RCEEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKY8vKrJ=BDOKd5hnZjiS7XO_u-Sz+PsOuymaDxJbHBP2RCEEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ernst Gunnar Gran <ernstgr-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/08/2013 10:01, Ernst Gunnar Gran wrote:
> I=92m about to start experimenting with SR-IOV and IB (ConnectX-2 G2,=
 HP DL360p Gen8, E5-2609). Is it OK to just download the latest OFED re=
lease and start playing, or are there any known issues that I should kn=
ow of when it comes to SR-IOV with the current release?

I would recommend using the IB/RDMA stack from the upstream kernel or=20
the one provided with one of the distros that picked SRIOV support from=
=20
upstream into the bits they ship. Note that IB and Ethernet are=20
supported for ConnectX VFs, but not yet RoCE.

Or.

Also note you need to do some preparations at the node (bios, kernel=20
boot command line) level and card (re-burn the firmware with sriov=20
support enabled, see the web or your mellanox rep) level.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
