From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: How far back does rdma-core X supports the kernel Y?
Date: Wed, 1 Nov 2017 12:07:07 +0000
Message-ID: <BN3PR07MB2578883C85DD3855C496F367F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,
I've installed rdma-core-15 on kernel 4.3 and ran into issues.

It seems this kernel doesn't include the following patch:
https://github.com/torvalds/linux/commit/aa744cc01fe0f21dfbe2744d3fd5f2fb32=
44c9b3

So IB_QP_SMAC is present in kernel 4.3 but not in rdma-core-15.
This caused a failure here:

int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
                      int attr_mask,
                      struct ibv_modify_qp *cmd, size_t cmd_size)
{
        /*
         * Masks over IBV_QP_DEST_QPN are only supported by
         * ibv_cmd_modify_qp_ex.
         */
        if (attr_mask & ~((IBV_QP_DEST_QPN << 1) - 1))
                return EOPNOTSUPP;
        ...
}

Do we expect these versions to operate?
If not, from what version do we support backward compatibility?
Are there any other backward compatibility issues you are aware of?

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
