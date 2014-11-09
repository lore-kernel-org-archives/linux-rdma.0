From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] infiniband-diags: add rdma-ndd daemon
Date: Sun, 9 Nov 2014 23:15:33 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CBA8F59@CRSMSX101.amr.corp.intel.com>
References: <1414780065-15267-1-git-send-email-ira.weiny@intel.com>
 <545CB84F.1070808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545CB84F.1070808-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eitan Zahavi <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >
> > rdma-ndd is a system daemon which watches the procfs hostname file for
> updates.
> >
> > Upon detecting an update it will update the Node Descriptions of the
> > RDMA devices in the system.
> 
> What is the effect of this on RoCE and IWARP adapters ? While they populate
> node_desc in sysfs, I don't think they support IB_DEVICE_MODIFY_NODE_DESC
> for ib_modify_device.

No they don't support it.

> 
> Shouldn't such devices be "skipped" in terms of setting NodeDescription ?

AFAIK all of the current user space software which write to the node_desc sysfs simply ignore any errors.  Those devices which do not support ib_modify_device return EIO from sysfs.  This is the same mechanism I used and should be safe.

If we want to go down this path[*] I think the core sysfs code should be changed such that the node_desc is either A) not available on those devices or B) not writable if ib_modify_device is not supported.

-- Ira

[*] Changing this sysfs behavior was not the intent of this patch series and I think should be dealt with separately.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
