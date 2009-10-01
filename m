From: "Sean Hefty" <sean.hefty@intel.com>
Subject: RE: [PATCH] typeof() not supported in Windows WDK compiler
Date: Thu, 1 Oct 2009 16:38:02 -0700
Message-ID: <9CD09AF98FCB471DB0AF4DAFF97A2434@amr.corp.intel.com>
References: <DB05C7E7F5BE4BE585F311B2437350A5@amr.corp.intel.com>
	<2A3759D0AB7F46D59DF8820EFCFAF1F8@amr.corp.intel.com>
	<3F6F638B8D880340AB536D29CD4C1E1912C86E8BB5@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C86E8BB5@orsmsx501.amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Smith, Stan" <stan.smith@intel.com>, 'Sasha Khapyorsky' <sashak@voltaire.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>>> 	while (!cl_is_qlist_empty(&p_port->mcm_list)) {
>>> +#ifndef __WIN__
>>> 		mcm_port = cl_item_obj(cl_qlist_head(&p_port->mcm_list),
>>> 				       mcm_port, list_item);
>>> +#else
>>> +		mcm_port = cl_item_obj(cl_qlist_head(&p_port->mcm_list),
>>> +				       mcm_port, list_item, (osm_mcm_port_t*) );
>>> +#endif
>>
>> I'd find this more readable if it were #ifdef rather than #ifndef.
>
>So would I, although the convention is to only define something extra for
>Windows.
>Perhaps a gcc/cpp defined item could be recommended and agreed upon?
>
>>
>> That said, I've got to believe that there's a better way to handle
>> these changes.  I just don't know what it is.
>
>Agreed, I'm listening.

How about replacing cl_item_obj with something more common, like container_of()?
