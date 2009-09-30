From: Guy Coates <gmpc-5fLPn3lgkryFxr2TtlUqVg@public.gmane.org>
Subject: Re: getting path to backport directory
Date: Wed, 30 Sep 2009 09:35:16 +0100
Message-ID: <4AC31844.8030304@sanger.ac.uk>
References: <Pine.LNX.4.64.0909291613310.13129@postal.iol.unh.edu> <4ac28072.jEyJX+IRBrF1KkkL%john.gregor@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ac28072.jEyJX+IRBrF1KkkL%john.gregor-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rdr-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

John A. Gregor wrote:
> "Robert D. Russell" <rdr-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org> wrote:
>> A general question on getting the correct backport.
>>
>> On my machine, if I do "uname -r" I get
>> 2.6.18-128.el5
>>
>> If I do "cat /etc/redhat-release" I get
>> CentOs release 5.3 (Final)
>>
>> If I look in "/usr/src/ofa_kernel/kernel_addons/backport"
>> the subdirectory I need to use for the current kernel is:
>> 2.6.18-EL5.3
>>
>> My question:  Is there somewhere in the system where I can
>> find (or generate) the string "2.6.18-EL5.3"?
>> I want to put that in my scripts so they will automatically
>> pick it up whenever we change versions (as we just did when
>> going to Centos -- it used to be 2.6.18-EL5.2 in the RedHat
>> version we were running before).  At present I have to edit
>> these scripts by hand, and that's a lousy way to do business.
>

You can force the ofa-kernel build system to use a specific backport by doing:

ofed_scripts/ofed_patch.sh --kernel-version=2.6.18-EL5.3
./configure ; make ; make install

That is handy if the kernel version contains extra bits that confuses the 
ofed_patch script.

Cheers,

Guy



-- 
Dr. Guy Coates,  Informatics System Group
The Wellcome Trust Sanger Institute, Hinxton, Cambridge, CB10 1HH, UK
Tel: +44 (0)1223 834244 x 6925
Fax: +44 (0)1223 496802


-- 
 The Wellcome Trust Sanger Institute is operated by Genome Research 
 Limited, a charity registered in England with number 1021457 and a 
 company registered in England with number 2742969, whose registered 
 office is 215 Euston Road, London, NW1 2BE. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
