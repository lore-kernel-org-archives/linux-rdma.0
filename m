From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2] infiniband-diags: add rdma-ndd daemon
Date: Fri, 07 Nov 2014 07:17:19 -0500
Message-ID: <545CB84F.1070808@dev.mellanox.co.il>
References: <1414780065-15267-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414780065-15267-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Eitan Zahavi <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/31/2014 2:27 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> rdma-ndd is a system daemon which watches the procfs hostname file for updates.
> 
> Upon detecting an update it will update the Node Descriptions of the RDMA
> devices in the system.

What is the effect of this on RoCE and IWARP adapters ? While they
populate node_desc in sysfs, I don't think they support
IB_DEVICE_MODIFY_NODE_DESC for ib_modify_device.

Shouldn't such devices be "skipped" in terms of setting NodeDescription ?

-- Hal

> This deamon is intended to work with kernels which support polling of the
> procfs hostname file.  If your kernel does not support this feature the daemon
> will set the Node Descriptions to the hostname at start up and then sleep
> forever.
> 
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
