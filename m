From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC v2 00/10] HFI Virtual Network Interface Controller (VNIC)
Date: Thu, 15 Dec 2016 09:56:11 -0700
Message-ID: <20161215165611.GB3264@obsidianresearch.com>
References: <1481788782-89964-1-git-send-email-niranjana.vishwanathapura@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1481788782-89964-1-git-send-email-niranjana.vishwanathapura@intel.com>
Sender: netdev-owner@vger.kernel.org
To: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, dennis.dalessandro@intel.com, ira.weiny@intel.com
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 14, 2016 at 11:59:32PM -0800, Vishwanathapura, Niranjana wrote:
>  create mode 100644 drivers/infiniband/sw/intel/hfi_vnic/Kconfig
>  create mode 100644 drivers/infiniband/sw/intel/hfi_vnic/Makefile

Stil NAK on these paths, I already explained why 'sw' is totally
unsuitable. Put it in drivers/net or drivers/infiniband/ulp

Jason
