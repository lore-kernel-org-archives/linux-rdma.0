From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: sg_map failures when tuning SRP via ib_srp module parameters for
 maximum SG entries
Date: Sat, 12 Mar 2016 09:56:17 -0500 (EST)
Message-ID: <1195068688.21605141.1457794577569.JavaMail.zimbra@redhat.com>
References: <1213561283.21604993.1457793870012.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1213561283.21604993.1457793870012.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: James Hartsock <hartsjc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello

I am seeing and issue with 100Gbit EDR Infiniband (mlx5_ib and ConnectX-4) and connecting to high speed arrays when we tune the ib_srp parameters to maximum allowed values.

The tuning is being done to maximize performance using:

options ib_srp cmd_sg_entries=255 indirect_sg_entries=2048 

We get into a situation where in srp_queuecommand we fail the srp_map_data().

[  353.811594] scsi host4: ib_srp: Failed to map data (-5)
[  353.811619] scsi host4: Could not fit S/G list into SRP_CMD

On the array

[ 6097.205716] ib_srpt IB send queue full (needed 68)
[ 6097.233325] ib_srpt srpt_xfer_data[2731] queue full -- ret=-12

This is an issue with the latest upstream, RHEL7.2 and Mellanox code bases.

What is the impact of using allow_ext_sg=1 prefer_fr=1 to avoid the sg_map failures. 

If we cap the tuning at ib_srp cmd_sg_entries=128 indirect_sg_entries=512 we avoid this but this constrains the maximum performance that can be achieved. 


static int (struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
{

        len = srp_map_data(scmnd, ch, req);  --------------------------------------------------------- See (2) below
        if (len < 0) {
                shost_printk(KERN_ERR, target->scsi_host,
                             PFX "Failed to map data (%d)\n", len);
                /*
                 * If we ran out of memory descriptors (-ENOMEM) because an
                 * application is queuing many requests with more than
                 * max_pages_per_mr sg-list elements, tell the SCSI mid-layer
                 * to reduce queue depth temporarily.
                 */
                scmnd->result = len == -ENOMEM ?
                        DID_OK << 16 | QUEUE_FULL << 1 : DID_ERROR << 16;
                goto err_iu;
        }


[  353.811594] scsi host4: ib_srp: Failed to map data (-5)
[  353.811619] scsi host4: Could not fit S/G list into SRP_CMD
[  353.811620] scsi host4: ib_srp: Failed to map data (-5)
[  353.811637] scsi host4: Could not fit S/G list into SRP_CMD
[  353.811639] scsi host4: ib_srp: Failed to map data (-5)
[  353.811646] scsi host4: Could not fit S/G list into SRP_CMD
[  353.811647] scsi host4: ib_srp: Failed to map data (-5)
[  353.811652] scsi host4: Could not fit S/G list into SRP_CMD

My array logs the queue full.

On the array

[ 6097.205716] ib_srpt IB send queue full (needed 68)
[ 6097.233325] ib_srpt srpt_xfer_data[2731] queue full -- ret=-12
[ 6097.266589] ib_srpt IB send queue full (needed 69)
[ 6097.266988] ib_srpt IB send queue full (needed 67)
[ 6097.266990] ib_srpt srpt_xfer_data[2731] queue full -- ret=-12
[ 6097.269996] ib_srpt IB send queue full (needed 64)
[ 6097.269997] ib_srpt srpt_xfer_data[2731] queue full -- ret=-12


(2)  ************************************************************************************* (2)
static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_rdma_ch *ch,
                        struct srp_request *req)
{
 
..
..

        if (unlikely(target->cmd_sg_cnt < state.ndesc &&
                                                !target->allow_ext_sg)) {
                shost_printk(KERN_ERR, target->scsi_host,
                             "Could not fit S/G list into SRP_CMD\n");
                return -EIO;
        }
..
..


Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
