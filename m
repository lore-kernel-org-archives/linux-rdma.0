From: Yicheng Jia <YJia-EIlpL8JyKVZBDgjK7y7TUQ@public.gmane.org>
Subject: multiple QPs with different priorities
Date: Wed, 31 Aug 2011 10:39:06 -0500
Message-ID: <OF77A040F6.4196F19A-ON862578FD.0055E182-862578FD.0055FA83@TMRIUSA.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

All,

I have 2 QPs for my applications, QPn is for data and QPm is for message. 
I want to set up QPs' QoS so that packages from QPm(message) always go 
first than from QPn(data). Here are my network configuration:
1. HCA - MHES18XTC (InfiniHost III Lx SDR) with firmware 1.1.0
2. OpenSM - ver#3.2.1
3. Switch - managed/unmanaged switch

My questions are:
1. Does the HCA provide QoS function?
2. If it does, then is setting SL value of QP all that I need to do to 
enable QoS, like QPm.SL = 0 and QPn.SL = 1? Do I also need to configure 
the SLtoVLMapping table in the switch?

Thanks!
Yicheng Jia

Software Engineer
Toshiba Medical Research Institute USA, Inc.


_____________________________________________________________________________
Scanned by IBM Email Security Management Services powered by MessageLabs. For more information please visit http://www-935.ibm.com/services/us/index.wss/offerfamily/iss/a1026954
_____________________________________________________________________________
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
