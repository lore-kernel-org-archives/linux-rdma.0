From: javed-If5XQcfNmg0@public.gmane.org
Subject: release of debug/test tools for dapl and verbs
Date: Fri, 4 Dec 2009 21:33:50 +0530 (IST)
Message-ID: <Pine.LNX.4.62.0912042106220.7602@mailhub.cdac.in>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN;
	charset=US-ASCII;
	format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


hello,

following software tools have been released in public domain on 
sourceforge:

 	a. TED    - test environment for dapl
            http://sourceforge.net/projects/testdebugdapl/

 	b. VERTDE - verbs testing and debugging environment
            http://sourceforge.net/projects/vertde/

both the tools are meant to assist in testing/verification/debugging of 
uDAPL/verbs implementation as well as the underlying hardware i.e. Host
Channel Adapter (HCA).

TED and VERTDE were created for internal usage but may be useful to the 
community involved in development of dapl/verbs software stacks.

each tool provides a command line interface to enable protocol level 
testing of the respective library functions, device driver and HCA in an 
integrated manner. errors are logged. they support scripting for creating 
complex test cases.

can be used over any implementation of uDAPL/verbs over IB. there will be
regular updations with new features, bug fixes, docs etc. suggestions are 
welcome.

thanks for your time.

javed

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
