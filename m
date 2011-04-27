From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] opensm/osm_port: Add infrastructure for alias GUID
 support
Date: Wed, 27 Apr 2011 19:08:46 +0300
Message-ID: <20110427160846.GC1903@calypso.voltaire.com>
References: <4DA31781.7070606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DA31781.7070606-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 11:00 Mon 11 Apr     , Hal Rosenstock wrote:
> 
> alias GUIDs are those indicated in SM GUIDInfo attribute
> (other than index 0) and are created/removed via SA Set/Delete
> of GUIDInfoRecord per IBTA MgtWG errata RefIDs 4704-4706.
> 
> Up to now, this attribute was unneeded by the SM as only base port
> GUIDs were supported (and are available from the SM NodeInfo attribute).
> 
> In order to support alias GUIDs, a new alias GUID table is to be added
> indexed by alias GUID, each containing a pointer to the base port. The
> routines for creating and removing alias GUID table entries are added
> by this patch. Also, a pointer to the alias port GUIDs provided by the
> SM GUIDInfo attribute is added to the osm_physp_t structure.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Applied. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
