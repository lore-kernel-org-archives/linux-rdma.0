From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags] Close additional file descriptor in
 iblinkinfo in advance
Date: Wed, 22 Apr 2015 15:04:50 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E110607BC@CRSMSX101.amr.corp.intel.com>
References: <552FB794.7080503@dev.mellanox.co.il>,<20150422143221.GA28220@phlsvsds.ph.intel.com>
 <fx82yx4y90ielsvlcgq06v5k.1429713777113@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fx82yx4y90ielsvlcgq06v5k.1429713777113-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I may have incorrectly acked a patch on the list which I did not apply...

If so please ignore.

Sorry for the noise,
Ira

> -----Original Message-----
> From: Vladimir Koushnir [mailto:vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Wednesday, April 22, 2015 7:43 AM
> To: Weiny, Ira; Hal Rosenstock
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH infiniband-diags] Close additional file descriptor in
> iblinkinfo in advance
> 
> Thanks for figuring this out.
> I'll test on Sun and update.
> 
> "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> 
> On Thu, Apr 16, 2015 at 09:22:28AM -0400, Hal Rosenstock wrote:
> > From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Date: Tue, 14 Apr 2015 18:14:48 +0300
> >
> > Additional file descriptor for SMP MADs should be closed before
> > running
> > ibnd_discover_fabric() to avoid parallel usage of two SMP file
> > descriptors
> >
> > Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> I'm not quite sure why but this patch breaks the DR processing of iblinkinfo.
> 
> Please test iblinkinfo -D <path>
> 
> I don't have the time to figure this out at the moment.
> 
> Ira
> 
> > ---
> >  src/iblinkinfo.c |   16 ++++++++++------
> >  1 files changed, 10 insertions(+), 6 deletions(-)
> >
> > diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c index
> > 92ff3c6..9dcf698 100644
> > --- a/src/iblinkinfo.c
> > +++ b/src/iblinkinfo.c
> > @@ -594,6 +594,7 @@ int main(int argc, char **argv)
> >       ibnd_fabric_t *diff_fabric = NULL;
> >       struct ibmad_port *ibmad_port;
> >       ib_portid_t port_id = { 0 };
> > +     uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
> >       int mgmt_classes[3] =
> >           { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS };
> >
> > @@ -653,12 +654,20 @@ int main(int argc, char **argv)
> >               config.timeout_ms = ibd_timeout;
> >       }
> >
> > +     if (!smp_query_via(ni, &port_id, IB_ATTR_NODE_INFO, 0,
> > +                                ibd_timeout, ibmad_port)){
> > +                     mad_rpc_close_port(ibmad_port);
> > +                     fprintf(stderr,
> > +                             "Failed to get local Node Info\n");
> > +                     exit(1);
> > +     }
> >       config.flags = ibd_ibnetdisc_flags;
> >       config.mkey = ibd_mkey;
> >
> >       node_name_map = open_node_name_map(node_name_map_file);
> >
> >       if (dr_path && load_cache_file) {
> > +             mad_rpc_close_port(ibmad_port);
> >               fprintf(stderr, "Cannot specify cache and direct route path\n");
> >               exit(1);
> >       }
> > @@ -678,6 +687,7 @@ int main(int argc, char **argv)
> >                       IBWARN("Failed to resolve %s; attempting full scan\n",
> >                              guid_str);
> >       }
> > +     mad_rpc_close_port(ibmad_port);
> >
> >       if (diff_cache_file &&
> >           !(diff_fabric = ibnd_load_fabric(diff_cache_file, 0))) @@
> > -723,11 +733,6 @@ int main(int argc, char **argv)
> >                       fprintf(stderr, "Failed to find port: %s\n", guid_str);
> >       } else if (!all && dr_path) {
> >               ibnd_port_t *p = NULL;
> > -             uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
> > -
> > -             if (!smp_query_via(ni, &port_id, IB_ATTR_NODE_INFO, 0,
> > -                                ibd_timeout, ibmad_port))
> > -                     return -1;
> >               mad_decode_field(ni, IB_NODE_PORT_GUID_F, &(guid));
> >
> >               p = ibnd_find_port_guid(fabric, guid); @@ -758,6 +763,5
> > @@ int main(int argc, char **argv)
> >
> >  close_port:
> >       close_node_name_map(node_name_map);
> > -     mad_rpc_close_port(ibmad_port);
> >       exit(rc);
> >  }
> > --
> > 1.7.8.2
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
