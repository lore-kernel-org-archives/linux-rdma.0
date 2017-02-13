From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC v3 00/11] HFI Virtual Network Interface Controller (VNIC)
Date: Mon, 13 Feb 2017 10:09:35 -0700
Message-ID: <20170213170935.GD25430@obsidianresearch.com>
References: <1486498990-76562-1-git-send-email-niranjana.vishwanathapura@intel.com>
 <HE1PR0501MB2812C133C408A8092A745F82B1460@HE1PR0501MB2812.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <HE1PR0501MB2812C133C408A8092A745F82B1460@HE1PR0501MB2812.eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Liran Liss <liranl@mellanox.com>
Cc: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "dennis.dalessandro@intel.com" <dennis.dalessandro@intel.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 12, 2017 at 01:26:35PM +0000, Liran Liss wrote:
> > From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> > owner@vger.kernel.org] On Behalf Of Vishwanathapura, Niranjana
> 
> > 
> > ChangeLog:
> > =========
> > v2 => v3:
> > a) Introduce and adopt generic RDMA netdev interface including,
> >      - having bottom hfi1 driver directly interfacing with netstack.
> >      - optimizing interface between hfi_vnic and hfi1 driver.
> > b) Remove bitfield usage.
> > c) Move hfi_vnic driver to drivers/infiniband/ulp folder.
> 
> The vnic driver should be placed under drivers/infiniband/hw/hfi1/*
> since it is HFI-specific.

I think they should call it opa_vnic and keep it in ulp to avoid this
confusion.

Jason
