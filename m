From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH opensm] osm_sa_guidinfo_record.c: False duplicate GUID
 error messages
Date: Thu, 05 Sep 2013 21:15:45 +0200
Message-ID: <5228D861.3070206@oracle.com>
References: <522892BE.7070002@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <522892BE.7070002-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks good to me. Thanks,
Line

On 09/05/13 16:18, Hal Rosenstock wrote:
> If the same request is received twice then the second one will cause
> error messages indicating duplicate alias GUIDs. In this case this is
> a false warning. The second request should be treated as a void and
> return success to the requester.
>
> Signed-off-by: Line Holen<Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Hal Rosenstock<hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
> index 8323b38..28f6c0f 100644
> --- a/opensm/osm_sa_guidinfo_record.c
> +++ b/opensm/osm_sa_guidinfo_record.c
> @@ -653,15 +653,21 @@ add_alias_guid:
>   							    p_alias_guid->alias_guid,
>   							&p_alias_guid->map_item);
>   		if (p_alias_guid_check != p_alias_guid) {
> -			/* alias GUID is a duplicate */
> -			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5108: "
> -				"Duplicate alias port GUID 0x%" PRIx64
> -				" index %d base port GUID 0x%" PRIx64 "\n",
> -				cl_ntoh64(p_alias_guid->alias_guid), i,
> -				cl_ntoh64(p_alias_guid->p_base_port->guid));
> -			osm_alias_guid_delete(&p_alias_guid);
> -			/* clear response guid at index to indicate duplicate */
> -			p_rcvd_rec->guid_info.guid[i % 8] = 0;
> +			/* alias GUID is a duplicate if it exists on another port or on the same port but at another index */
> +			if (p_alias_guid_check->p_base_port != p_port ||
> +			    (*p_port->p_physp->p_guids)[i] != set_alias_guid) {
> +				OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5108: "
> +					"Duplicate alias port GUID 0x%" PRIx64
> +					" index %d base port GUID 0x%" PRIx64
> +					", alias GUID already assigned to "
> +					"base port GUID 0x%" PRIx64 "\n",
> +					cl_ntoh64(p_alias_guid->alias_guid), i,
> +					cl_ntoh64(p_alias_guid->p_base_port->guid),
> +					cl_ntoh64(p_alias_guid_check->p_base_port->guid));
> +				osm_alias_guid_delete(&p_alias_guid);
> +				/* clear response guid at index to indicate duplicate */
> +				p_rcvd_rec->guid_info.guid[i % 8] = 0;
> +			}
>   		} else {
>   			del_alias_guid = (*p_port->p_physp->p_guids)[i];
>   			if (del_alias_guid) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
