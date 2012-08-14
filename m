From: Christian Mohrbacher <christian.mohrbacher-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Setting service level for a QP with ibv_modify_qp and RDMA_CM
Date: Tue, 14 Aug 2012 11:26:45 +0200
Message-ID: <502A19D5.70007@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
we are trying to set the service level for a QP with ibv_modify_qp, but 
ibv_modify_qp() returns an error (errno = EINVAL).

We are using RDMA CM and use rdma_create_qp() to allocate the queue 
pair. After some searching in the net we found posts, which indicate 
that ibv_modify_qp() cannot be used to set the service level, if you are 
using RDMA CM. Can anybody confirm or negate this assumption and are 
there alternatives?

Best regards,
Christian

---

Christian Mohrbacher
Fraunhofer HPC
FhGFS Team
http://www.fhgfs.com

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
