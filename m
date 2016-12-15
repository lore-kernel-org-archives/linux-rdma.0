From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC v2 03/10] IB/hfi-vnic: Virtual Network Interface Controller
 (VNIC) netdev
Date: Thu, 15 Dec 2016 10:24:37 -0700
Message-ID: <20161215172437.GA11387@obsidianresearch.com>
References: <1481788782-89964-1-git-send-email-niranjana.vishwanathapura@intel.com>
 <1481788782-89964-4-git-send-email-niranjana.vishwanathapura@intel.com>
 <20161215170109.GC3264@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0C9556@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0C9556@ORSMSX109.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Warrier, Sadanand" <sadanand.warrier@intel.com>, "Dutt, Sudeep" <sudeep.dutt@intel.com>, "Jajodia, Tanya K" <tanya.k.jajodia@intel.com>, "Kacprowski, Andrzej" <Andrzej.Kacprowski@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 15, 2016 at 05:21:05PM +0000, Hefty, Sean wrote:
> > This goes on the network too? Also looks like it has endian problems.
> 
> I don't think OPA supports BE systems, and I think it uses LE on the
> wire for at least some portions of its protocol.

This is a linux driver for a PCI device.

It needs to support big endian systems, that is how we do things in
Linux.

If it uses LE on the wire then mark with __le and make it sparse clean.

Do not use bitfields without providing a BE version of the bitfield.

Jason
