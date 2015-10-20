From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/23] Update driver to 0.9-294
Date: Tue, 20 Oct 2015 15:45:47 +0300
Message-ID: <CAG9sBKM+hidZi8i+1=dZowT5Pw+bYq21LHvPPZMqpmxPFNSRug@mail.gmail.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
	<20151019165408.GA30921@kroah.com>
	<2807E5FD2F6FDA4886F6618EAC48510E1CBCA641@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1CBCA641-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> Perhaps I did not chose my words carefully enough.
>
> The largest issue on the TODO list is the refactoring of the code to be shared between the hfi1 and qib driver.  While the hardware between hfi1 and qib is similar and thus the initial code looked similar, our performance tuning on hfi1 has revealed that some changes will be required to the hfi1 code to fully utilize the hardware.  We would like to get these updates in to make sure that the refactoring work is done properly for the 2 hardware types.
Please keep in mind that there are 3 HW types (our SoftRoCE driver)
that needs to be part of the framework.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
