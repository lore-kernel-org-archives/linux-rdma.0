From: Lee Hilton Savoie <lsavoie-J82dVEKiPgWwMxdmafFHj4dd74u8MsAO@public.gmane.org>
Subject: Changing the service level of a qp
Date: Mon, 29 May 2017 10:01:07 -0700
Message-ID: <CAB-SxCMW8s47a8LDj4B0F0PvamCnsez3UfFGG01xR8Ue0ecBxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm trying to change the service level of a qp with service type
IBV_QPT_RC.  The qp has already been initialized and is in the RTS
state.  Based on the documentation, it seems I should be able to use
ibv_modify_qp to transition the qp to SQD, change the service level,
and then transition it back to RTS, but when I try to change the
service level I get EINVAL.  Is there a way to change the service
level of a qp that has already been set up?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
