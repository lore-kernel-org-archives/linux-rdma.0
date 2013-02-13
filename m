From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH v4 7/9] rdma/cm: Add helper functions to return id address
 information
Date: Wed, 13 Feb 2013 14:44:09 +0200
Message-ID: <511B8A99.70607@mellanox.com>
References: <1358891797-14625-1-git-send-email-sean.hefty@intel.com> <1358891797-14625-8-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1358891797-14625-8-git-send-email-sean.hefty@intel.com>
Sender: netdev-owner@vger.kernel.org
To: sean.hefty@intel.com
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 22/01/2013 23:56, sean.hefty@intel.com wrote:
> Provide inline helpers to extract source and destination address data from the rdma_cm_id.

Sean,

FWIW - this patch and most of patch #6 can (and worth doing) be 
introduced as cleanup/maintenance patches to the rdma-cm without direct 
relation to the AF_IB effort.

Or.
