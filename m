From: Ernst Gunnar Gran <ernstgr-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: Re: IB SR-IOV
Date: Wed, 14 Aug 2013 13:15:54 +0200
Message-ID: <CAKY8vKrqm9fYDybnzKgLbCSLkiBKim1nOtnKnx3CSco2UQK+Hw@mail.gmail.com>
References: <CAKY8vKrJ=BDOKd5hnZjiS7XO_u-Sz+PsOuymaDxJbHBP2RCEEQ@mail.gmail.com>
	<5209D8B3.7030309@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5209D8B3.7030309-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 13 August 2013 08:56, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 12/08/2013 10:01, Ernst Gunnar Gran wrote:
>>
>> I=92m about to start experimenting with SR-IOV and IB
>> (ConnectX-2 G2, HP DL360p Gen8, E5-2609). Is it OK to
>> just download the latest OFED release and start playing, or
>> are there any known issues that I should know of when it
> > comes to SR-IOV with the current release?
>
> I would recommend using the IB/RDMA stack from the
> upstream kernel or the one provided with one of the distros
> that picked SRIOV support from upstream into the bits they
> ship. Note that IB and Ethernet are supported for
> ConnectX VFs, but not yet RoCE.
>
> Or.
>
> Also note you need to do some preparations at the node
> (bios, kernel boot command line) level and card (re-burn
> the firmware with sriov support enabled, see the web
> or your mellanox rep) level.

Thank you Or (and Amir) for your quick reply and valuable information.

Ernst
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
